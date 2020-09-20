import React from "react";
import { newContextComponents } from "@drizzle/react-components";

const { AccountData, ContractData, ContractForm } = newContextComponents;

export default ({ drizzle, drizzleState }) => {
  // destructure drizzle and drizzleState from props

  return (
    <div className="App">

      {/* <div className="section">
        <h2>Active Account</h2>
        <AccountData
          drizzle={drizzle}
          drizzleState={drizzleState}
          accountIndex={0}
          units="ether"
          precision={3}
        />
      </div> */}

      <div className="section">

        <p>
          <h1>Appraise These Poems:</h1>

          <ContractData
            drizzle={drizzle}
            drizzleState={drizzleState}
            contract="Universe"
            method="getTwoPoems"

          />
        </p>
        <h1>Now Select One Poem Over Another</h1>
        <ContractForm 
          drizzle={drizzle} 
          drizzleState={drizzleState}
          contract="Universe" 
          method="selectPoem" 
          sendArgs=""
          labels={["Selected Poem", "Rejected Poem"]} 
        />

        <h1>You can find the dictionary here:</h1>

          <ContractData
            drizzle={drizzle}
            drizzleState={drizzleState}
            contract="Universe"
            method="getDictionary"

          />
      </div>
    </div>
  );
};
