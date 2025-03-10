import { promises as fs } from 'fs';
const path = "data/users.json";

export async function readUsers(){
    const data = await fs.readFile(path);
    return JSON.parse(data);
}

export async function registerUser(user){
    const data = await fs.readFile(path);
    const parsed = JSON.parse(data);

    parsed.push(user);

    await fs.writeFile(path, JSON.stringify(parsed, null, 2));
}