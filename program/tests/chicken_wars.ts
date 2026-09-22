import * as anchor from "@coral-xyz/anchor";
import { Program } from "@coral-xyz/anchor";
import { ChickenWars } from "../target/types/chicken_wars";
import { expect } from "chai";

describe("chicken_wars", () => {
  // Configure the client to use the local cluster or devnet
  const provider = anchor.AnchorProvider.env();
  anchor.setProvider(provider);

  const program = anchor.workspace.ChickenWars as Program<ChickenWars>;

  it("Initializes the Chicken Wars program", async () => {
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
    console.log("✅ Chicken Wars program initialized successfully!");
  });
});
