/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run `npm run dev` in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run `npm run deploy` to publish your worker
 *
 * Bind resources to your worker in `wrangler.toml`. After adding bindings, a type definition for the
 * `Env` object can be regenerated with `npm run cf-typegen`.
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

export default {
	async fetch(request, env, _ctx): Promise<Response> {
		const url = new URL(request.url);
		const pathname = url.pathname;

		if (pathname.startsWith('/api/')) {
			return await proxy(request, env.API_URL);
		}
		return await proxy(request, env.WEB_CLIENT_URL);
	},
} satisfies ExportedHandler<Env>;

async function proxy(req: Request, to: string): Promise<Response> {
	const url = new URL(req.url);
	url.hostname = to;
	const response = await fetch(url);
	return new Response(response.body as BodyInit, response);
}
