// test_login_selenium.js
// Integration test UI form login với Selenium (Node.js)

const { Builder, By, until } = require("selenium-webdriver");
const chrome = require("selenium-webdriver/chrome");
const assert = require("assert");

const BASE_URL = process.env.BASE_URL || "http://localhost:5000";
const HEADLESS = 0; //process.env.HEADLESS !== "0"; // mặc định chạy headless, HEADLESS=0 để thấy browser

async function run() {
  const options = new chrome.Options();
  if (HEADLESS) {
    options.addArguments("--headless=new");
    options.addArguments("--no-sandbox", "--disable-dev-shm-usage");
  }

  const driver = await new Builder()
    .forBrowser("chrome")
    .setChromeOptions(options)
    .build();

  // set timeout toàn cục 30 giây
  await driver.manage().setTimeouts({ implicit: 30000 });

  try {
    console.log("1) TC-LI1: Login thành công");
    await driver.get(`${BASE_URL}/index.html`);
    await driver.findElement(By.id("username")).sendKeys("employee1");
    await driver.findElement(By.id("password")).sendKeys("123456");
    await driver.findElement(By.id("loginBtn")).click();

    // chờ alert trong tối đa 30 giây
    await driver.wait(until.alertIsPresent(), 30000);
    const alert = await driver.switchTo().alert();
    const alertText = await alert.getText();
    assert.strictEqual(alertText, "Đăng nhập thành công!");
    await alert.accept();
    console.log("  → Passed");

    console.log("2) TC-LI4: Bỏ trống password -> báo lỗi");
    await driver.get(`${BASE_URL}/index.html`);
    await driver.findElement(By.id("username")).sendKeys("employee1");
    await driver.findElement(By.id("password")).clear();
    await driver.findElement(By.id("loginBtn")).click();

    const errBox = await driver.wait(
      until.elementLocated(By.id("errorBox")),
      30000
    );
    const errText = await errBox.getText();
    assert.strictEqual(errText, "Mật khẩu tối thiểu 6 ký tự");
    console.log("  → Passed");

    console.log("3) Toggle hiện/ẩn mật khẩu");
    await driver.get(`${BASE_URL}/index.html`);
    await driver.findElement(By.id("password")).sendKeys("abcdef");
    const toggle = await driver.findElement(By.id("togglePass"));

    await toggle.click();
    const typeAfter = await driver
      .findElement(By.id("password"))
      .getAttribute("type");
    assert.strictEqual(typeAfter, "text");

    await toggle.click();
    const typeBack = await driver
      .findElement(By.id("password"))
      .getAttribute("type");
    assert.strictEqual(typeBack, "password");
    console.log("  → Passed");

    console.log("4) Checkbox Remember + nút Cancel");
    await driver.get(`${BASE_URL}/index.html`);
    const uname = await driver.findElement(By.id("username"));
    const remember = await driver.findElement(By.id("remember"));
    await uname.sendKeys("employee1");
    await remember.click();

    await driver.findElement(By.id("password")).sendKeys("123456");
    await driver.findElement(By.id("loginBtn")).click();
    await driver.wait(until.alertIsPresent(), 30000);
    await (await driver.switchTo().alert()).accept();

    // check localStorage
    const saved = await driver.executeScript(
      "return window.localStorage.getItem('restaurant_login');"
    );
    assert.ok(saved && saved.includes('"u"'));
    console.log("  → localStorage saved, Passed");

    // click Cancel để clear
    await driver.findElement(By.id("cancelBtn")).click();
    const unameVal = await driver
      .findElement(By.id("username"))
      .getAttribute("value");
    assert.strictEqual(unameVal, "");
    const afterSaved = await driver.executeScript(
      "return window.localStorage.getItem('restaurant_login');"
    );
    assert.strictEqual(afterSaved, null);
    console.log("  → Cancel clears, Passed");

    console.log("✅ Tất cả test UI đã chạy thành công!");
  } catch (err) {
    console.error("❌ Test failed:", err);
    process.exitCode = 1;
  } finally {
    await driver.quit();
  }
}

run();
