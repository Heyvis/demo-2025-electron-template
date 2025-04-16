import { Client } from 'pg';

export default async () => {
  const client = new Client({
    user: 'electron',
    password: '123test',
    host: 'localhost',
    port: '5433',
    database: 'electron',
  });

  await client.connect();
  return client;
};
