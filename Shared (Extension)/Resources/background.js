browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
browser.runtime.sendNativeMessage("lrc.timenote", { message: "timenote update",req: request }, () => {
    if (browser.runtime.lastError) {
        console.error("Error sending native message:", browser.runtime.lastError);
    } else {
        console.log("Native message sent successfully.");
    }
});
});