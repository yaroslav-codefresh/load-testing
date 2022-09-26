import { sleep, check } from 'k6';
import http from 'k6/http';
import { SharedArray } from 'k6/data';
import { scenario, instance, vu } from 'k6/execution';

const DEBUG = true
// const ENDPOINT = '/api/graphql' // local
const VUS = 100
// const ENDPOINT = '/app-proxy/api/graphql'
const ENDPOINT = '/test1'

// tunnels-10
const API_KEY = '632b3b65a6e2dc9251a84414.14bfbe93d4fd771694ab74262d592687'

// prod
// const API_KEY = '62448a7f3eb3eddae3c948cb.e0c56d47b523f948f8d5fb0250287150'
const INTERVAL_SEC = 1

function debug(...rest) {
    if (DEBUG) {
        console.log(...rest)
    }
}

const tunnelsArr = new SharedArray('tunnels', function () {
    return JSON.parse(open('./tunnels.json')).tunnels;
});

// const tunnelsArr = [
//     'https://inc03.cf-op.com/app-proxy/api/graphql'
// ]

// const tunnelsArr = [
//     'https://test1.tunnels10.dev.codefresh.io'
// ]

// const tunnelsArr = [
//     'https://yaroslav.pipeline-team.cf-cd.com'
// ]

export const options = {
    scenarios: {
        'thousand-vus': {
            executor: 'constant-vus',
            vus: VUS,
            duration: '10m'
        }
    },
};

const graphqlQuery = `
 query Me {
   me
 }`;

export default function () {
    // const tunnelToUse = tunnelsArr[scenario.iterationInTest % tunnelsArr.length]

//     console.log(`
//     Iteration id: ${vu.iterationInInstance}
//     Iteration in scenario: ${vu.iterationInScenario}
//     VU ID in instance: ${vu.idInInstance}
//     VU ID in test: ${vu.idInTest}
// `)

    const tunnelToUse = tunnelsArr[vu.iterationInInstance * vu.idInInstance % tunnelsArr.length]
    // const tunnelToUse = tunnelsArr[0]
    console.log(`using tunnel: ${tunnelToUse}`);
    const host = tunnelToUse.replace('https://', '')
    const [name] = host.split('\.')

    const headers = {
        'Authorization': `Bearer ${API_KEY}`,
        'Content-Type': 'application/json',
    };

    const url = `${tunnelToUse}/${name}`
    debug(`sending request to ${url}`)

    const response = http.post(url, JSON.stringify({ query: graphqlQuery }), {
        headers: headers,
    });

    check(response, {
        'status is 200': (r) => r.status === 200
    });

    debug('response code: ', response.status)
    debug('response body: ', response.body)

    sleep(INTERVAL_SEC)
}
