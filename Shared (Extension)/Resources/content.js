window.setInterval(() => {
    const video = document.getElementsByTagName("video")[0];
    if (video) {
        const currentTime = video.currentTime;
        browser.runtime.sendMessage({ currentTime }).then((response) => {
        console.log("Received response: ", response);
});
    }
}, 1000);


browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    console.log("Received request: ", request);
});
