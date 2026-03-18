const express = require("express");
const { MongoClient } = require("mongodb");

const app = express();
app.use(express.json());

const uri = "mongodb://mongodb-service:27017";
const client = new MongoClient(uri);

let collection;

async function init() {
  await client.connect();
  const db = client.db("btechStories");
  collection = db.collection("success");
}

app.post("/create", async (req, res) => {
  const result = await collection.insertOne(req.body);
  res.send(result);
});

app.get("/read", async (req, res) => {
  const data = await collection.find().toArray();
  res.send(data);
});

app.put("/update", async (req, res) => {
  await collection.updateOne(
    { name: req.body.name },
    { $set: { mood: req.body.mood } }
  );
  res.send("Updated");
});

app.delete("/delete", async (req, res) => {
  await collection.deleteOne({ name: req.body.name });
  res.send("Deleted");
});

init().then(() => {
  app.listen(3000, () => console.log("Server running"));
});