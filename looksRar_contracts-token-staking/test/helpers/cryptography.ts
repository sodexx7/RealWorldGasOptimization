import { MerkleTree } from "merkletreejs";
import { utils } from "ethers/lib/ethers";

const { keccak256, solidityKeccak256 } = utils;

/**
 * Compute the cryptographic hash using keccak256
 * @param user address of the user
 * @param amount amount for a user
 * @dev Do not forget to multiply by 10e18 for decimals
 */
export function computeHash(user: string, amount: string): Buffer {
  return Buffer.from(solidityKeccak256(["address", "uint256"], [user, amount]).slice(2), "hex");
}

/**
 * Compute a merkle tree and return the tree with its root
 * @param tree merkle tree
 * @returns 2-tuple with merkle tree object and hexRoot
 */
export function createMerkleTree(tree: Record<string, string>): [MerkleTree, string] {
  const merkleTree = new MerkleTree(
    Object.entries(tree).map((data) => computeHash(...data)),
    keccak256,
    { sortPairs: true }
  );

  const hexRoot = merkleTree.getHexRoot();
  return [merkleTree, hexRoot];
}

/**
 * Compute the cryptographic hash using keccak256
 * @param user address of the user
 * @param amount amount for a user
 * @dev Do not forget to multiply by 10e18 for decimals
 */
export function computeDoubleHash(user: string, amount: string): Buffer {
  return Buffer.from(keccak256(computeHash(user, amount)).slice(2), "hex");
}

/**
 * Compute a merkle tree and return the tree with its root
 * @param tree merkle tree
 * @returns 2-tuple with merkle tree object and hexRoot
 */
export function createDoubleHashMerkleTree(tree: Record<string, string>): [MerkleTree, string] {
  const merkleTree = new MerkleTree(
    Object.entries(tree).map((data) => computeDoubleHash(...data)),
    keccak256,
    { sortPairs: true }
  );

  const hexRoot = merkleTree.getHexRoot();
  return [merkleTree, hexRoot];
}
