import fs from 'fs';
import path from 'path';

const DATA_DIR = path.resolve(__dirname, '..', '..', 'data');
const MEM_FILE = path.join(DATA_DIR, 'memory.json');

class MemoryManager {
  _data: Record<string, any> = {};
  constructor() {
    try {
      if (!fs.existsSync(DATA_DIR)) fs.mkdirSync(DATA_DIR);
      if (fs.existsSync(MEM_FILE)) {
        const raw = fs.readFileSync(MEM_FILE, 'utf-8');
        this._data = JSON.parse(raw);
      } else {
        fs.writeFileSync(MEM_FILE, JSON.stringify({}), 'utf-8');
      }
    } catch (e) {
      console.warn('MemoryManager init failed', e);
      this._data = {};
    }
  }

  async getAll() { return { ...this._data }; }
  async remember(key: string, value: any) { this._data[key] = value; await this._persist(); }
  async delete(key: string) { delete this._data[key]; await this._persist(); }
  async filteredMemoryForPrompt() { return { ...this._data }; }

  async _persist() {
    fs.writeFileSync(MEM_FILE, JSON.stringify(this._data, null, 2), 'utf-8');
  }
}

export default MemoryManager;
