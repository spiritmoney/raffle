
import {DeployFunction} from "hardhat-deploy/types"
import {HardhatRuntimeEnvironment} from "hardhat/types"

import { ethers } from "hardhat";

import {
    networkConfig,
    developmentChains,
    VERIFICATION_BLOCK_CONFIRMATIONS,
}  from "../helper-hardhat-config"
import verify from "../utils/verify"

const FUND_AMOUNT = "1000000000000000000000"

const deployRaffle: DeployFunction = async function (
    hre: HardhatRuntimeEnvironment
  ) {
    const { deployments, getNamedAccounts, network, ethers } = hre
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId
    // const chainId = 31337
    let vrfCoordinatorV2Address: string | undefined, subscriptionId: string | undefined, nftRewardAddress: string | undefined

    if (chainId == 31337) {
        // create VRFV2 Subscription
        const vrfCoordinatorV2Mock = await ethers.getContract("VRFCoordinatorV2Mock")
        vrfCoordinatorV2Address = vrfCoordinatorV2Mock.address
        const transactionResponse = await vrfCoordinatorV2Mock.createSubscription()
        const transactionReceipt = await transactionResponse.wait()
        subscriptionId = transactionReceipt.events[0].args.subId
        // Fund the subscription
        // Our mock makes it so we don't actually have to worry about sending fund
        await vrfCoordinatorV2Mock.fundSubscription(subscriptionId, FUND_AMOUNT)
    } else {
        vrfCoordinatorV2Address = networkConfig[network.config.chainId!]["vrfCoordinatorV2"]
        subscriptionId = networkConfig[network.config.chainId!]["subscriptionId"]
        nftRewardAddress = networkConfig[network.config.chainId!]["nftRewardAddress"]
    }
    const waitBlockConfirmations = developmentChains.includes(network.name)
        ? 1
        : VERIFICATION_BLOCK_CONFIRMATIONS

    log("----------------------------------------------------")
    const args: any[] = [
        vrfCoordinatorV2Address,
        subscriptionId,
        networkConfig[network.config.chainId!]["gasLane"],
        networkConfig[network.config.chainId!]["keepersUpdateInterval"],
        networkConfig[network.config.chainId!]["raffleEntranceFee"],
        networkConfig[network.config.chainId!]["callbackGasLimit"],
        nftRewardAddress,
    ]
    const raffle = await deploy("Raffle", {
        from: deployer,
        args: args,
        log: true,
        waitConfirmations: waitBlockConfirmations,
    })

    // Verify the deployment
    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        log("Verifying...")
        await verify(raffle.address, args)
    }

    log("Run Price Feed contract with command:")
    const networkName = network.name == "hardhat" ? "localhost" : network.name
    log(`yarn hardhat run scripts/enterRaffle.ts --network ${networkName}`)
    log("----------------------------------------------------")
}
export default deployRaffle
deployRaffle.tags = ["all", "raffle"]


// interface Deployments {
//     deploy: Function // Replace Function with a more specific type if possible
// }

// interface NamedAccounts {
//     deployer: string
// }

// const ENTRANCE_FEE = ethers.utils.parseEther("0.01")

// module.exports = async ({ getNamedAccounts, deployments }: {getNamedAccounts: () => Promise<NamedAccounts>, deployments: Deployments }) => {
//     const { deploy } = deployments;
//     const { deployer } = await getNamedAccounts();

//     await deploy("Raffle", {
//         from: deployer,
//         args: [
//             "0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B",
//             "69093496915893036751649966106646175515611241822984067150785576259265085359454",
//             "0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae",
//             "300",
//             ENTRANCE_FEE,
//             "500000",
//             "0x2C13c417C73c181F02341BB72aCF625aFc9A4d0c",
//         ],
//         log: true,
//         waitConfirmations: 6,
//     })
// }