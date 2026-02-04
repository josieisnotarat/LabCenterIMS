const { spawn } = require('child_process');
const electronPath = require('electron');

const child = spawn(electronPath, ['.'], {
  stdio: 'inherit'
});

child.on('exit', (code) => {
  process.exit(code ?? 0);
});
