//--no-sandbox flag is required if run with sudo
const puppeteer = require('puppeteer');

function run () {
    return new Promise(async (resolve, reject) => {
		try {
    const browser = await puppeteer.launch({ headless: true,
//		executablePath: 'C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe',  
  args: [
    '--use-fake-ui-for-media-stream',
//    '--use-fake-device-for-media-stream',
//   '--autoplay-policy=no-user-gesture-required',
//	'--use-file-for-fake-audio-capture=/usr/local/nginx/html/newtest.wav',
//	'--use-file-for-fake-video-capture=/usr/local/nginx/scripts/tmp/browservideo1_pipe.mjpeg',
// Need to run on linux - https://github.com/puppeteer/puppeteer/issues/3443#issuecomment-433096772	
//	'--no-sandbox',
//	'--user-data-dir=C:\\Users\\Streaming\\AppData\\Local\\Google\\Chrome\\User Data',
//	'--profile-directory=Profile 2'
  ],
  ignoreDefaultArgs: ['--mute-audio'],
});
console.log("Browser launched");
  const page = await browser.newPage();
  // To check devices if needed
  // await page.setViewport({ width: 900, height: 1600 });
  // await page.goto('https://obs.ninja/devices', { waitUntil: 'networkidle2' });
  await page.goto('https://obs.ninja/?view=stimulus', { waitUntil: 'networkidle2' });
 });
  // Check audio if needed, to narrow down to mic & camera permissions issue
  // await page.goto('https://www.youtube.com/embed/v5GNBQDU0j0?autoplay=true', { waitUntil: 'networkidle2' });
  console.log("Page loaded");
  await page.screenshot({ path: 'example1.png' });

// To click play on YouTube --> get play btn selector and click
//await page.click(
//    "#movie_player > div.ytp-chrome-bottom > div.ytp-chrome-controls > div.ytp-left-controls > button[aria-label='Play (k)'"
//  );

  // Start the OBS Ninja video
  await page.waitForSelector('#bigPlayButton');
  console.log("Buttoned");
  await page.screenshot({ path: 'example2.png' }); 
  
  // Generally click is not required. But just in case.
// await page.click('#bigPlayButton');
// console.log("Clicked");
// await page.screenshot({ path: 'example3.png' });

  await page.waitForTimeout(10500);
  console.log("Timeout");
  await page.screenshot({ path: 'example3.png' });

  // Never close the Browser 
//  await browser.close();
return resolve();
console.log("After resolve");
        } catch (e) {
            return reject(e);
        }
    })
}
run().then(console.log).catch(console.error);

