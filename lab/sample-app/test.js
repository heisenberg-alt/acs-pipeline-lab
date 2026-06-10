// Minimal smoke test for the sample app — run with `npm test`.
const http = require('http');
const { spawn } = require('child_process');

const app = spawn('node', ['server.js'], { env: { ...process.env, PORT: 3999 } });

setTimeout(() => {
  const req = http.request(
    { hostname: 'localhost', port: 3999, path: '/contact', method: 'POST', headers: { 'Content-Type': 'application/json' } },
    (res) => {
      let body = '';
      res.on('data', (c) => (body += c));
      res.on('end', () => {
        app.kill();
        const out = JSON.parse(body);
        if (res.statusCode === 200 && out.ok) {
          console.log('✅ smoke test passed');
          process.exit(0);
        }
        console.error('❌ smoke test failed:', res.statusCode, body);
        process.exit(1);
      });
    }
  );
  req.on('error', (e) => { app.kill(); console.error('❌', e.message); process.exit(1); });
  req.end(JSON.stringify({ name: 'Ada', email: 'ada@example.com', message: 'hi' }));
}, 500);
