// =============================================================
// Part 2 — MongoDB Operations
// Collection: products
// Run with: mongosh <db_name> mongo_queries.js
// =============================================================

// OP1: insertMany() — insert all 3 documents from sample_documents.json
db.products.insertMany([
  {
    _id: "PROD001",
    product_name: "Samsung Galaxy S24 Ultra",
    category: "Electronics",
    brand: "Samsung",
    price: 124999,
    currency: "INR",
    in_stock: true,
    stock_quantity: 45,
    specifications: {
      display: "6.8-inch Dynamic AMOLED",
      processor: "Snapdragon 8 Gen 3",
      ram_gb: 12,
      storage_gb: 256,
      battery_mah: 5000,
      camera_mp: 200,
      os: "Android 14"
    },
    warranty: {
      duration_months: 12,
      type: "manufacturer",
      covers: ["hardware defects", "battery", "display"]
    },
    voltage: "5V / 45W fast charging",
    certifications: ["BIS", "SAR compliant"],
    tags: ["smartphone", "5G", "flagship"],
    ratings: { average: 4.6, count: 2341 },
    added_date: "2024-01-20"
  },
  {
    _id: "PROD002",
    product_name: "Men's Slim Fit Chinos",
    category: "Clothing",
    brand: "Peter England",
    price: 1299,
    currency: "INR",
    in_stock: true,
    stock_quantity: 120,
    specifications: {
      fabric: "98% Cotton, 2% Elastane",
      fit: "Slim Fit",
      occasion: ["casual", "semi-formal"],
      care_instructions: ["machine wash cold", "do not bleach", "tumble dry low"],
      country_of_origin: "India"
    },
    available_variants: [
      { color: "Navy Blue",   sizes: ["28", "30", "32", "34", "36"] },
      { color: "Olive Green", sizes: ["30", "32", "34"] },
      { color: "Beige",       sizes: ["28", "30", "32", "34", "36", "38"] }
    ],
    gender: "Men",
    age_group: "Adult",
    tags: ["chinos", "cotton", "office wear"],
    ratings: { average: 4.2, count: 876 },
    added_date: "2023-09-15"
  },
  {
    _id: "PROD003",
    product_name: "Organic Whole Wheat Atta 10kg",
    category: "Grocery",
    brand: "Aashirvaad",
    price: 489,
    currency: "INR",
    in_stock: true,
    stock_quantity: 300,
    specifications: {
      weight_kg: 10,
      form: "powder",
      grain_type: "whole wheat",
      milling: "stone ground"
    },
    nutritional_info: {
      serving_size_g: 100,
      energy_kcal: 341,
      carbohydrates_g: 69.4,
      protein_g: 12.0,
      fat_g: 1.7,
      fibre_g: 1.9,
      sodium_mg: 37
    },
    expiry_info: {
      manufactured_date: "2023-12-01",
      expiry_date: "2024-11-30",
      shelf_life_months: 12
    },
    certifications: ["FSSAI", "Organic India certified", "ISO 22000"],
    allergens: ["wheat", "gluten"],
    storage_instructions: "Store in a cool, dry place. Keep away from moisture.",
    tags: ["atta", "organic", "whole wheat", "staple"],
    ratings: { average: 4.5, count: 15432 },
    added_date: "2024-11-05"
  }
]);

// OP2: find() — retrieve all Electronics products with price > 20000
db.products.find(
  {
    category: "Electronics",
    price: { $gt: 20000 }
  },
  {
    product_name: 1,
    brand: 1,
    price: 1,
    category: 1,
    "ratings.average": 1
  }
);

// OP3: find() — retrieve all Groceries expiring before 2025-01-01
db.products.find(
  {
    category: "Grocery",
    "expiry_info.expiry_date": { $lt: "2025-01-01" }
  },
  {
    product_name: 1,
    brand: 1,
    "expiry_info.expiry_date": 1,
    "expiry_info.shelf_life_months": 1
  }
);

// OP4: updateOne() — add a "discount_percent" field to a specific product
// Adding a 10% discount to the Samsung Galaxy S24 Ultra (PROD001)
db.products.updateOne(
  { _id: "PROD001" },
  {
    $set: {
      discount_percent: 10,
      discounted_price: 112499.10
    }
  }
);

// OP5: createIndex() — create an index on category field and explain why
// An index on 'category' speeds up all queries that filter by category (OP2, OP3).
// Without this index, MongoDB performs a full collection scan (O(n)) on every
// category-based query. With the index, lookups become O(log n) using a B-tree,
// which is critical as the product catalog grows to millions of documents.
db.products.createIndex(
  { category: 1 },
  { name: "idx_category", background: true }
);

// Verify the index was created
db.products.getIndexes();
