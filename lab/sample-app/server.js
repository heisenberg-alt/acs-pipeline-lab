// ACS Pipeline Lab — sample contact-form API.
// This is the ONLY area the agent may modify (see .github/agent-control.yml).
const http = require('http');

const PORT = process.env.PORT || 3000;

// Lab Exercise 4: ask the Copilot coding agent to add input validation here.
function handleContact(body) {
  const data = JSON.parse(body);
  return { ok: true, received: { name: data.name, email: data.email, message: data.message } };
}

const server = http.createServer((req, res) => {
  if (req.method === 'POST' && req.url === '/contact') {
    let body = '';
    req.on('data', (chunk) => (body += chunk));
    req.on('end', () => {
      try {
        const result = handleContact(body);
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(result));
      } catch {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ ok: false, error: 'invalid request' }));
      }
    });
    return;
  }
  res.writeHead(200, { 'Content-Type': 'text/html' });
  res.end(`<h1>🛡️ ACS Pipeline Lab</h1>
    <p>Sample app is running. POST JSON to <code>/contact</code>.</p>
    <p>Open <code>lab/README.md</code> for the lab guide.</p>`);
});

server.listen(PORT, () => console.log(`Lab sample app listening on http://localhost:${PORT}`));
