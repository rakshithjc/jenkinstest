module.exports = {
  HOST: process.env.PG_HOST,
  USER: process.env.PG_PASSWORD,
  PASSWORD: "5432",
  DB: process.env.PG_DB,
  dialect: "postgres",
  pool: {
    max: 5,
    min: 0,
    acquire: 30000,
    idle: 10000
  }
};
