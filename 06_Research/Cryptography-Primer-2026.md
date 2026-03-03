# Cryptography: A Practical Primer

*From Ancient Ciphers to Post-Quantum Standards — What You Need to Know*

---

## Introduction: Why Cryptography Matters to You

Every time you send a Signal message, log into your bank, or browse with HTTPS, cryptography is doing invisible work. It's the mathematics of secrets — the science of making information unreadable to anyone except the intended recipient.

You already *use* cryptography daily (FileVault, iCloud ADP, Mullvad VPN, Proton Mail). This guide helps you *understand* it — not to become a cryptographer, but to make informed decisions about your digital life and potentially apply it in your Apple IT career.

---

## Part I: The Foundations

### What Is Cryptography?

**Plain English:** Cryptography is the practice of converting readable information (plaintext) into unreadable gibberish (ciphertext) using mathematical algorithms, and then converting it back for the intended recipient.

**The Three Pillars:**

| Pillar | What It Protects | Example |
|--------|-----------------|---------|
| **Confidentiality** | Only intended recipients can read it | Encrypted email |
| **Integrity** | Data hasn't been tampered with | File checksums |
| **Authentication** | Verifies who sent it | Digital signatures |

### A Brief History (The Fun Parts)

- **~1900 BCE:** Egyptians used non-standard hieroglyphs to obscure meaning
- **~50 BCE:** Caesar cipher — shift each letter by 3 positions (A→D, B→E)
- **1467:** Leon Battista Alberti invents polyalphabetic cipher (multiple substitution alphabets)
- **1918:** The Enigma machine — Nazi Germany's "unbreakable" encryption (spoiler: broken by Alan Turing and Polish mathematicians)
- **1976:** Diffie-Hellman key exchange — the birth of public-key cryptography
- **1977:** RSA algorithm published — still in use today (sort of)
- **1991:** Phil Zimmermann creates PGP (Pretty Good Privacy) — brings encryption to the masses
- **2001:** AES (Advanced Encryption Standard) replaces DES — currently the gold standard
- **2013:** Signal Protocol created — end-to-end encryption for messaging
- **2024:** NIST publishes first post-quantum cryptography standards — preparing for quantum computers

---

## Part II: How Encryption Actually Works

### Symmetric Encryption: One Key to Rule Them All

**Concept:** Same key encrypts and decrypts.

**Analogy:** A lockbox. You and your friend both have copies of the same key. You lock the box, send it, they unlock it.

**Real-world algorithm:** **AES-256** (Advanced Encryption Standard, 256-bit key)
- Used by: FileVault, Mullvad VPN, Signal (for message content), most HTTPS connections
- Strength: Would take billions of years to brute-force with current computers
- Weakness: How do you safely share the key in the first place?

**Academic foundation:**
> Daemen, J. & Rijmen, V. "The Design of Rijndael: AES — The Advanced Encryption Standard." *Springer-Verlag* (2002). — The original paper describing the AES algorithm selected by NIST.

---

### Asymmetric Encryption: The Key Pair

**Concept:** Two mathematically related keys — one public, one private.

**Analogy:** A mailbox. Anyone can drop a letter in (public key = the slot), but only you have the key to open it (private key).

**How it works:**
1. You generate a **key pair** (public + private)
2. You share your **public key** with the world
3. Someone encrypts a message using your **public key**
4. Only your **private key** can decrypt it
5. If you lose your private key, the data is gone forever

**Real-world algorithms:**
- **RSA** (1977) — the original, still widely used but being phased out
- **ECC** (Elliptic Curve Cryptography) — smaller keys, same security, more efficient
- **Ed25519** — modern elliptic curve, used in SSH keys and Signal

**Academic foundation:**
> Rivest, R., Shamir, A., & Adleman, L. "A Method for Obtaining Digital Signatures and Public-Key Cryptosystems." *Communications of the ACM* 21(2), 120–126 (1978). — The RSA paper, one of the most cited in computer science.

> Diffie, W. & Hellman, M. "New Directions in Cryptography." *IEEE Transactions on Information Theory* 22(6), 644–654 (1976). — The paper that started public-key cryptography.

---

### Hashing: The One-Way Street

**Concept:** Convert any data into a fixed-length "fingerprint." Irreversible — you can't get the original data back from the hash.

**Analogy:** A meat grinder. You can turn a steak into ground beef, but you can't reassemble the steak.

**Uses:**
- **Password storage:** Your bank doesn't store your password — it stores the hash
- **File integrity:** Download a file, check its hash matches the published one
- **Digital signatures:** Hash the message, encrypt the hash with your private key
- **Blockchain:** Each block's hash depends on the previous block

**Real-world algorithms:**
- **SHA-256** — current standard (used in Bitcoin, TLS, file verification)
- **SHA-3** — newer, different mathematical approach
- **bcrypt/Argon2** — designed specifically for password hashing (intentionally slow)

**Academic foundation:**
> NIST. "FIPS 180-4: Secure Hash Standard (SHS)." (2015). — The federal standard defining SHA-256 and related algorithms.

---

### How They Work Together

Modern encryption typically combines all three:

1. **Asymmetric** encryption establishes a shared secret (key exchange)
2. **Symmetric** encryption handles the bulk data (faster)
3. **Hashing** verifies integrity and creates signatures

**Example: HTTPS connection to your bank:**
1. Your browser and the bank exchange public keys (asymmetric)
2. They agree on a shared AES session key (using Diffie-Hellman)
3. All data transfers use AES-256 (symmetric — fast)
4. SHA-256 hashes verify nothing was tampered with
5. Digital certificates (signed by Certificate Authorities) prove the bank is real

---

## Part III: Cryptography You're Already Using

### Signal Protocol (Your Signal & WhatsApp Messages)

**What it does:** End-to-end encryption with **forward secrecy** — even if someone compromises your long-term keys, past messages remain encrypted.

**How:** Uses a "Double Ratchet" algorithm — generates new encryption keys for every single message. Each message has its own unique key that's destroyed after use.

**Academic foundation:**
> Cohn-Gordon, K., et al. "A Formal Security Analysis of the Signal Messaging Protocol." *IEEE European Symposium on Security and Privacy* (2017). — Formal verification that Signal's protocol is cryptographically sound.

### FileVault (Your Mac's Disk Encryption)

**What it does:** Encrypts your entire disk with AES-256-XTS.

**How:** Your login password derives an encryption key that unlocks the disk. Without it, the data is meaningless binary noise.

**Why it matters:** If someone steals your MacBook, they get a very expensive paperweight, not your data.

### iCloud Advanced Data Protection

**What it does:** End-to-end encrypts most iCloud data (backups, photos, notes, etc.)

**How:** Encryption keys are stored on your devices, not Apple's servers. Apple cannot decrypt your data even if compelled by law enforcement.

**Why you enabled it:** Because you understand that "the cloud" is just someone else's computer, and you'd rather that computer couldn't read your files.

### Mullvad VPN

**What it does:** Encrypts your internet traffic between your device and Mullvad's servers.

**How:** Uses WireGuard protocol (ChaCha20 encryption + Curve25519 key exchange + BLAKE2s hashing).

**Why:** Your ISP can't see what you're doing. Public WiFi can't sniff your traffic.

### Proton Mail (Your Email)

**What it does:** End-to-end encrypts email between Proton users. Uses PGP-based encryption.

**How:** Your private key never leaves your device. Proton's servers store only encrypted blobs they cannot read.

---

## Part IV: Post-Quantum Cryptography — The Next Frontier

### The Quantum Threat

**The problem:** Quantum computers (when they're powerful enough) could break RSA and ECC encryption in hours instead of billions of years. This affects most current public-key cryptography.

**The timeline:** Estimates vary from 5-15 years for "cryptographically relevant" quantum computers. But the threat is **now** — adversaries can capture encrypted data today and decrypt it later ("harvest now, decrypt later").

### NIST Post-Quantum Standards (2024)

In August 2024, NIST released the first three finalized post-quantum cryptography standards:

| Standard | Algorithm | Purpose |
|----------|-----------|---------|
| **FIPS 203** | ML-KEM (based on CRYSTALS-Kyber) | Key encapsulation (key exchange) |
| **FIPS 204** | ML-DSA (based on CRYSTALS-Dilithium) | Digital signatures |
| **FIPS 205** | SLH-DSA (based on SPHINCS+) | Hash-based digital signatures |

A fourth standard based on **FALCON** is in development (FIPS 206).

**What this means for you:**
- Your current encryption (AES-256) is **quantum-resistant** (symmetric encryption is safe)
- Public-key systems (RSA, ECC) will need to migrate to these new standards
- This transition will take years — but it's already happening
- Chrome, Cloudflare, and Signal have already begun testing post-quantum key exchange

**Academic foundation:**
> NIST. "NIST IR 8547: Transition to Post-Quantum Cryptography Standards." (2024). — NIST's roadmap for migrating from classical to post-quantum cryptography.

> Frontiers in Physics (2025): "Design and implementation of an authenticated post-quantum session protocol using ML-KEM (Kyber), ML-DSA (Dilithium), and AES-256-GCM." — Practical benchmarking of the new standards.

---

## Part V: Practical Applications for Beginners

### 1. GPG/PGP: Encrypt Your Email (Manually)

**What:** Generate a key pair, share your public key, encrypt/decrypt emails and files.

**Setup on macOS:**
```bash
# Install GPG
brew install gnupg

# Generate a key pair
gpg --full-generate-key
# Choose: RSA and RSA, 4096 bits, set expiration

# List your keys
gpg --list-keys

# Export your public key (share this)
gpg --armor --export your@email.com > public-key.asc

# Encrypt a file for someone
gpg --encrypt --recipient their@email.com secret.txt

# Decrypt a file sent to you
gpg --decrypt secret.txt.gpg
```

**Already done for you:** Proton Mail handles PGP automatically. This is for when you need manual encryption outside of email.

---

### 2. SSH Keys: Secure Remote Access

**What:** Public-key authentication for connecting to servers (no passwords).

**Setup on macOS:**
```bash
# Generate an Ed25519 key pair (modern, recommended)
ssh-keygen -t ed25519 -C "xena@macbook"

# Your keys are at:
# ~/.ssh/id_ed25519 (PRIVATE — never share)
# ~/.ssh/id_ed25519.pub (PUBLIC — share freely)

# Copy public key to a server
ssh-copy-id user@server-ip
```

**Relevant to Jamf Pro:** Remote server management, automation scripts, secure deployments.

---

### 3. File Encryption: Encrypt Individual Files

**Using GPG:**
```bash
# Encrypt with a passphrase (symmetric)
gpg --symmetric --cipher-algo AES256 sensitive-file.pdf

# Decrypt
gpg --decrypt sensitive-file.pdf.gpg > sensitive-file.pdf
```

**Using macOS built-in (disk images):**
```bash
# Create an encrypted disk image
hdiutil create -size 100m -encryption AES-256 -stdinpass -volname "Secrets" secrets.dmg
```

---

### 4. Password Management (Bitwarden)

**What you already do:** Use Bitwarden (AES-256-CBC encryption, PBKDF2 key derivation).

**Best practice:** Use a **strong master password** (5+ random words) + **YubiKey** for 2FA. Your vault is encrypted locally before it touches Bitwarden's servers.

---

### 5. Verify File Integrity (Checksums)

**When downloading software, verify the hash:**
```bash
# Generate SHA-256 hash of a downloaded file
shasum -a 256 downloaded-file.dmg

# Compare with the published hash on the developer's site
```

**Why:** Ensures the file hasn't been tampered with during download.

---

## Part VI: Best Practices (The Rules)

### The Golden Rules of Cryptography

1. **Never roll your own crypto.** Use established, peer-reviewed algorithms. Inventing your own encryption is like performing your own surgery — technically possible, almost certainly fatal.

2. **Use the strongest available standard.** AES-256 for symmetric. Ed25519 or ECDSA for keys. SHA-256+ for hashing. Don't use MD5 or SHA-1 (broken).

3. **Key management is everything.** The algorithm is public. The key is the secret. Protect your private keys like your life depends on it (digitally, it does).

4. **Assume the adversary has the algorithm.** Kerckhoffs' principle (1883): A cryptosystem should be secure even if everything about the system, except the key, is public knowledge.

5. **Update regularly.** Cryptographic best practices evolve. What was secure in 2010 may not be in 2026.

6. **Use end-to-end encryption when possible.** If the service provider can read your data, so can a hacker who compromises the provider.

7. **Enable 2FA everywhere.** Preferably hardware keys (YubiKey). SMS is better than nothing but vulnerable to SIM-swap attacks.

8. **Encrypt at rest AND in transit.** FileVault = at rest. VPN/HTTPS = in transit. Both matter.

---

## Part VII: Where Cryptography Meets Your Career

### Apple IT + Cryptography

| Topic | Relevance |
|-------|-----------|
| **FileVault management** | Deploying/managing disk encryption across device fleets |
| **MDM certificates** | Jamf Pro uses certificates for device authentication |
| **Code signing** | Apple's code signing system uses cryptographic signatures |
| **Keychain** | macOS credential management is cryptography-based |
| **Network security** | VPN, TLS/SSL certificates, Wi-Fi encryption (WPA3) |
| **APFS encryption** | Apple File System's native encryption layer |

**Practical tip:** Understanding cryptography makes Jamf Pro cert material *much* easier. MDM profiles, SCEP certificates, and push notification encryption all rely on concepts in this guide.

---

## Sources and Further Reading

### Academic Sources (Peer-Reviewed)

- **Rivest, R., Shamir, A., & Adleman, L.** "A Method for Obtaining Digital Signatures and Public-Key Cryptosystems." *Communications of the ACM* 21(2), 120–126 (1978).

- **Diffie, W. & Hellman, M.** "New Directions in Cryptography." *IEEE Transactions on Information Theory* 22(6), 644–654 (1976).

- **Daemen, J. & Rijmen, V.** *The Design of Rijndael: AES — The Advanced Encryption Standard.* Springer-Verlag (2002).

- **Cohn-Gordon, K., et al.** "A Formal Security Analysis of the Signal Messaging Protocol." *IEEE European Symposium on Security and Privacy* (2017).

- **NIST.** "FIPS 203: Module-Lattice-Based Key-Encapsulation Mechanism Standard (ML-KEM)." (2024).

- **NIST.** "FIPS 204: Module-Lattice-Based Digital Signature Standard (ML-DSA)." (2024).

- **NIST.** "FIPS 205: Stateless Hash-Based Digital Signature Standard (SLH-DSA)." (2024).

- **NIST.** "NIST IR 8547: Transition to Post-Quantum Cryptography Standards." (2024).

- **Frontiers in Physics (2025):** "Design and implementation of an authenticated post-quantum session protocol using ML-KEM, ML-DSA, and AES-256-GCM."

- **MDPI Cryptography Journal** — Open-access peer-reviewed journal covering applied cryptography (Vols. 8-10, 2024-2026).

### Books for Beginners

- **"Serious Cryptography" by Jean-Philippe Aumasson** — Best modern introduction. Clear, practical, not dumbed down.

- **"Crypto" by Steven Levy** — History of cryptography's culture wars (the Cypherpunks, PGP, government backdoor debates). Reads like a thriller.

- **"The Code Book" by Simon Singh** — From Egyptian ciphers to quantum cryptography. Accessible, engaging, historical.

- **"Applied Cryptography" by Bruce Schneier** — The classic reference. Dense but authoritative.

### Free Online Resources

- **Khan Academy: Cryptography** — Visual, interactive introduction
- **Crypto101.io** — Free introductory cryptography textbook
- **Christof Paar's Lectures** — University-level crypto course (YouTube, with slides)

---

## Glossary

| Term | Meaning |
|------|---------|
| **Plaintext** | Readable data before encryption |
| **Ciphertext** | Encrypted, unreadable data |
| **Key** | The secret value used to encrypt/decrypt |
| **Symmetric encryption** | Same key encrypts and decrypts (AES) |
| **Asymmetric encryption** | Key pair — public encrypts, private decrypts (RSA, ECC) |
| **Hash** | One-way function producing a fixed-length fingerprint (SHA-256) |
| **Digital signature** | Proves who sent a message and that it wasn't altered |
| **Forward secrecy** | Past messages stay encrypted even if keys are compromised later |
| **End-to-end encryption (E2EE)** | Only sender and recipient can read the data |
| **Post-quantum cryptography** | Algorithms resistant to quantum computer attacks |
| **Key exchange** | Process of safely agreeing on a shared encryption key |
| **Certificate** | A digitally signed document binding a public key to an identity |
| **NIST** | National Institute of Standards and Technology (sets crypto standards) |

---

*Prepared for Xena Vexus Nox by Rudolf | Researched via Brave Search + Google Scholar + NIST archives*

*"Privacy is not about having something to hide. It's about having something to protect." — Edward Snowden*
