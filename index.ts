import express from "express";

const app = express();
app.use(express.json());
const port = process.env.PORT ?? 1e4;

app.get("/", (_req, res) => {
    res.send("works!");
});

app.listen(port, () => {
    console.log(`listening on port ${port}`);
});
