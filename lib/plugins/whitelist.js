var url = require("url");

module.exports = {
	init: () => {
		this.ALLOWED_DOMAINS = (process.env.ALLOWED_DOMAINS && process.env.ALLOWED_DOMAINS.split(',')) || [];
	},
	requestReceived: (req, res, next) => {
		let parsed = url.parse(req.prerender.url);
		// Allow any domain if "X-Uwai-Auth" header is valid.
		let auth = req.headers['x-uwai-auth'];

		if (this.ALLOWED_DOMAINS.indexOf(parsed.hostname) > -1 || auth == process.env.UWAI_AUTH) {
			next();
		} else {
			res.send(404);
		}
	}
}