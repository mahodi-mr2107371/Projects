import { promises as fs } from 'fs';
const path = "data/papers.json";

export async function readPapers(){
    const data = await fs.readFile(path);
    return JSON.parse(data);
}