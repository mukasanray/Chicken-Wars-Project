import * as anchor from "@coral-xyz/anchor";
import { Program } from "@coral-xyz/anchor";
import { FowlgenWars } from "../target/types/fowlgen_wars";
import { expect } from "chai";

describe("fowlgen_wars", () => {
  // Configure the client to use the local cluster or devnet
  const provider = anchor.AnchorProvider.env();
  anchor.setProvider(provider);

  const program = anchor.workspace.FowlgenWars as Program<FowlgenWars>;

  it("Initializes the Fowlgen Wars program", async () => {
    // Chama a instrução initialize
    const tx = await program.methods
      .initialize()
      .accounts({
        signer: provider.wallet.publicKey,
      })
      .rpc();

    console.log("Transaction signature:", tx);

    // Se chegou aqui sem erro, a instrução foi executada com sucesso
    expect(tx).to.be.a("string");
    console.log("✅ Fowlgen Wars program initialized successfully!");
  });
});
