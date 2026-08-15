import { readFile } from 'node:fs/promises';

const schema=await readFile(new URL('../schema.sql',import.meta.url),'utf8');
const worker=await readFile(new URL('../src/worker.js',import.meta.url),'utf8');
const frontend=await readFile(new URL('../public/index.html',import.meta.url),'utf8');
const requiredTables=['users','vehicles','bookings','trips','inspections','damages','maintenance','insurance_claims','washing_log','audit_log'];
for(const table of requiredTables)if(!schema.includes(`CREATE TABLE IF NOT EXISTS ${table}`))throw new Error(`Missing table: ${table}`);
for(const route of ['/api/bootstrap','/api/bookings','/api/vehicles','/api/damages','/api/claims','checkin','checkout','complete','washing'])if(!worker.includes(route))throw new Error(`Missing workflow route: ${route}`);
for(const section of ['dashboard','vehicles','bookings','trips','maintenance','washing','admin'])if(!frontend.includes(`data-section="${section}"`))throw new Error(`Missing frontend section: ${section}`);
console.log(`webapp smoke tests passed: ${requiredTables.length} tables, ${requiredTables.length-4} workflow checks, 7 frontend sections`);
