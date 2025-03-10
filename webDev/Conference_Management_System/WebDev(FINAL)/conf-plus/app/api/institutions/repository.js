import { promises as fs } from 'fs';
const path = "data/institutions.json";

export async function readInst(){
    const data = await fs.readFile(path);
    return JSON.parse(data);
}

