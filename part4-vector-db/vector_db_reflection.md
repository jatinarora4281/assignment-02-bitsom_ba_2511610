## Vector DB Use Case

### Scenario

A law firm wants to build a system where lawyers can search 500-page contracts by asking questions in plain English — for example, "What are the termination clauses?" The question is whether a traditional keyword-based database search would suffice, and what role a vector database plays.

---

### Why Keyword Search Falls Short

Traditional keyword-based search (like SQL `LIKE` queries or inverted index systems such as Elasticsearch in basic mode) matches documents based on the *literal words* in the query. For contract search, this approach fails in three critical ways.

**1. Vocabulary mismatch.** A lawyer might ask "What happens if we want to end the agreement early?" The contract may never use the words "end" or "early" — it may say "early termination", "unilateral dissolution", or "right of rescission". Keyword search misses all of these. A vector database, by contrast, maps both the query and the contract clauses into the same semantic space — the embedding for "end the agreement" is close to "termination clause" even though they share no words.

**2. Semantic ambiguity.** The word "liability" appears in indemnity clauses, limitation-of-liability clauses, and product liability sections. A keyword search for "liability" returns all of them indiscriminately. A vector search for "Who is responsible if the software causes data loss?" returns specifically the sections about software-related liability, ranked by semantic relevance.

**3. 500-page scale.** Manual reading is impractical. Keyword search returns entire sections containing a word; vector search returns the specific paragraphs that semantically answer the question.

---

### Role of a Vector Database

The system would work as follows: each paragraph or clause in the contract is split into chunks, embedded using a model like `all-MiniLM-L6-v2` or a legal-domain model (e.g., `legal-bert`), and stored in a vector database such as Pinecone or Chroma. When a lawyer asks "What are the termination clauses?", the query is embedded and the vector database returns the top-k most semantically similar chunks. These chunks are then passed to an LLM (retrieval-augmented generation / RAG) to generate a coherent, grounded answer.

This approach is more accurate, faster, and safer than keyword search for legal documents — the vector database ensures only relevant clauses are retrieved, and the LLM explains them in plain language rather than forcing the lawyer to read raw contract text.
