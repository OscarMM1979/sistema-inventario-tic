const os = require('os');
const fs = require('fs');
const path = require('path');

class Scanner {
    constructor() {
        this.data = {
            hostname: os.hostname(),
            platform: os.platform(),
            arch: os.arch(),
            cpus: os.cpus().length,
            totalMemory: Math.round(os.totalmem() / (1024 * 1024 * 1024)) + ' GB',
            freeMemory: Math.round(os.freemem() / (1024 * 1024 * 1024)) + ' GB',
            uptime: Math.round(os.uptime() / 3600) + ' horas',
            timestamp: new Date().toISOString()
        };
    }

    scan() {
        console.log('Escaneando equipo...');
        console.log('Sistema operativo:', this.data.platform);
        console.log('Hostname:', this.data.hostname);
        console.log('CPUs:', this.data.cpus);
        console.log('Memoria total:', this.data.totalMemory);
        console.log('Memoria libre:', this.data.freeMemory);
        return this.data;
    }

    saveToFile() {
        const filePath = path.join(__dirname, '../data', 'last_scan.json');
        if (!fs.existsSync(path.dirname(filePath))) {
            fs.mkdirSync(path.dirname(filePath), { recursive: true });
        }
        fs.writeFileSync(filePath, JSON.stringify(this.data, null, 2));
        console.log('Datos guardados en:', filePath);
    }
}

module.exports = Scanner;