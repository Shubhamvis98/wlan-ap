{%

'use strict';
push(REQUIRE_SEARCH_PATH, "/usr/share/uspot/*.uc");

let uci = require('uci').cursor();
let config = uci.get_all('uspot');
let portal = require('portal');

function request_mac_login(ctx) {
        portal.debug(ctx, 'start ' + (ctx.config.auth_mode || '') + ' flow');
        switch (ctx.config.auth_mode) {
        case 'uam':
                // try mac-auth first if enabled
                if (+ctx.config.mac_auth) {
                        let payload = portal.radius_init(ctx);
                        payload.username = ctx.format_mac + (ctx.config.mac_suffix || '');
                        payload.password = ctx.config.mac_passwd || ctx.format_mac;
                        payload.service_type = 10;      // Call-Check, see https://wiki.freeradius.org/guide/mac-auth#web-auth-safe-mac-auth
                        let radius = portal.radius_call(ctx, payload);
                        if (radius['access-accept']) {
                                if (ctx.config.final_redirect_url == 'uam')
                                        ctx.query_string.userurl = portal.uam_url(ctx, 'success');
                                delete payload.server;  // don't publish radius secrets
                                portal.allow_client(ctx, { radius: { reply: radius.reply, request: payload } } );
                                return;
                        }
                }
                return;
        default:
                include('error.uc', ctx);
                return;
        }
}


global.handle_request = function(env) {
	let ctx = portal.handle_request(env);

	request_mac_login(ctx);

	if (env.REMOTE_ADDR && +config?.def_captive?.debug)
		warn('uspot: ' + env.REMOTE_ADDR + ' - CPD redirect\n');
	include('cpd.uc', { env });
};
%}
