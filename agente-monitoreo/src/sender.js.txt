const http = require('http');
const Scanner = require('./scanner');

class Sender {
    constructor(config) {
        this.config = config || {
            backendUrl: 'http://localhost:3000',
            interval: 300000 // 5 minutos
        };
        this.scanner = new Scanner();
    }

    async sendData() {
        const data = this.scanner.scan();
        
        const postData = JSON.stringify({
            id_equipo: this.config.equipoId || 1,
            fecha: new Date().toISOString(),
            estado_equipo: 'activo',
            alerta_detectada: false,
            datos_hardware: data
        });

        const options = {
            hostname: 'localhost',
            port: 3000,
            path: '/api/monitoreo/data',
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': Buffer.byteLength(postData)
            }
        };

        return new Promise((resolve, reject) => {
            const req = http.request(options, (res) => {
                let responseData = '';
                res.on('data', (chunk) => {
                    responseData += chunk;
                });
                res.on('end', () => {
                    console.log('Respuesta del servidor:', responseData);
                    resolve(responseData);
                });
            });

            req.on('error', (error) => {
                console.error('Error al enviar datos:', error.message);
                reject(error);
            });

            req.write(postData);
            req.end();
        });
    }

    start() {
        console.log('Iniciando agente de monitoreo...');
        console.log('Intervalo:', this.config.interval / 1000, 'segundos');
        
        this.sendData().catch(err => console.error('Error inicial:', err.message));
        
        setInterval(() => {
            this.sendData().catch(err => console.error('Error en ciclo:', err.message));
        }, this.config.interval);
    }
}

module.exports = Sender;