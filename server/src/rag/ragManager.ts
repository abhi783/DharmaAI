class Document {
  id: string;
  title: string;
  content: string;
  type: string;
  constructor(id: string, title: string, content: string, type: string) {
    this.id = id; this.title = title; this.content = content; this.type = type;
  }
}

export class RAGResult {
  sourceId: string;
  type: string;
  excerpt: string;
  constructor(sourceId: string, type: string, excerpt: string) { this.sourceId = sourceId; this.type = type; this.excerpt = excerpt; }
}

class RAGManager {
  private _docs: Document[] = [];
  constructor() {
    this._loadDefaults();
  }
  private _loadDefaults() {
    this._docs.push(new Document('gita_meta', 'Bhagavad Gita (Index)', 'Bhagavad Gita index and verified mapping', 'scripture_gita'));
    this._docs.push(new Document('ram_meta', 'Ramayanam (Index)', 'Ramayanam index and summaries', 'scripture_ramayanam'));
    this._docs.push(new Document('maha_meta', 'Mahabharatam (Index)', 'Mahabharatam index and summaries', 'scripture_mahabharatam'));
  }
  async addDocument(doc: Document) { this._docs.push(doc); }
  async search(query: string, max = 3): Promise<RAGResult[]> {
    const q = query.toLowerCase();
    const results: RAGResult[] = [];
    for (const d of this._docs) {
      if (d.title.toLowerCase().includes(q) || d.content.toLowerCase().includes(q)) {
        const idx = d.content.toLowerCase().indexOf(q);
        const excerpt = idx >= 0 ? d.content.substring(Math.max(0, idx - 40), Math.min(d.content.length, idx + 120)) : d.content.substring(0, Math.min(140, d.content.length));
        results.push(new RAGResult(d.title, d.type, excerpt.replace(/\n/g, ' ')));
        if (results.length >= max) break;
      }
    }
    return results;
  }
  async searchRelevant(query: string) { return this.search(query); }
}

export default RAGManager;
