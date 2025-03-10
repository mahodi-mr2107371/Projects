import { promises as fs } from 'fs';
const path = "data/locations.json";

export async function readLoc(){
    const data = await fs.readFile(path);
    return JSON.parse(data);
}

