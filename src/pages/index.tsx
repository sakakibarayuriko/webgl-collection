import Head from "next/head";
import Image from "next/image";
import Link from "next/link";
import styles from "../styles/Home.module.css";

export default function Home() {
  return (
    <div className={styles.container}>
      <Head>
        <title>WebGL Collection</title>
        <meta name="description" content="WebGL Collection" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>WebGL Collection</h1>
        <div className={styles.grid}>
          <Link href="/neon_circle" className={styles.card}>
            Neon Circle
          </Link>
          <Link href="/glow_metaball" className={styles.card}>
            Glow Metaball
          </Link>
          <Link href="/colorful_noise" className={styles.card}>
            Colorful Noise
          </Link>
          <Link href="/cellular_noise" className={styles.card}>
            Cellular Noise
          </Link>
          <Link href="/domain_warping" className={styles.card}>
            Domain Warping
          </Link>
          <Link href="/bubble" className={styles.card}>
            Bubble
          </Link>
          <Link href="/glitch_image" className={styles.card}>
            Glitch Image
          </Link>
        </div>
      </main>
    </div>
  );
}
