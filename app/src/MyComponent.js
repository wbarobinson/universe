import React from "react";
import { newContextComponents } from "@drizzle/react-components";

const { AccountData, ContractData, ContractForm } = newContextComponents;

export default ({ drizzle, drizzleState }) => {
  // destructure drizzle and drizzleState from props

  return (
    <div className="App">

      <div className="section">
        <h2>Active Account</h2>
        <AccountData
          drizzle={drizzle}
          drizzleState={drizzleState}
          accountIndex={0}
          units="ether"
          precision={3}
        />
      </div>

      <div className="section">

        <p>
          <strong>The Poems of Our Generation </strong>
          {/* <ContractData
            drizzle={drizzle}
            drizzleState={drizzleState}
            contract="Universe"
            method="getPoem"
            methodArgs=""
          /> */}
          <ContractData
            drizzle={drizzle}
            drizzleState={drizzleState}
            contract="Universe"
            method="getTwoPoems"
          />
        </p>
        <strong>Select a Poem over Another</strong>
        <ContractForm 
          drizzle={drizzle} 
          drizzleState={drizzleState}
          contract="Universe" 
          method="selectPoem" 
          sendArgs=""
          labels={["Selected Poem", "Rejected Poem"]} 
        />
      </div>
    </div>
  );
};
