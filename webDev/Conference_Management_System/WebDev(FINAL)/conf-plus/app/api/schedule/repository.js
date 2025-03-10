import { promises as fs } from 'fs';
const path = "data/schedule.json";

export async function readSch(){
    const data = await fs.readFile(path);
    return JSON.parse(data);
}

export async function registerSession(schedule){
    await fs.writeFile(path, JSON.stringify(schedule, null, 2));
}