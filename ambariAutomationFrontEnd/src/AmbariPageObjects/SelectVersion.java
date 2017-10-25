package AmbariPageObjects;

import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.annotations.Test;


public class SelectVersion 
{
	//declare variables
	protected WebDriver driver;
	protected WebDriverWait wait;
	
	
	@FindBy(css="button[class= 'btn btn-success pull-right']")
	protected WebElement buttonNext;
	
	//constructor
	public SelectVersion(WebDriver driver)
	{
		this.driver=driver;
		this.wait = new WebDriverWait(driver, 180);
		this.driver.manage().window().maximize();
	}

    @Test
	public void SelectVersionProcess(String majorVersions,String minorVersions) throws InterruptedException
	{
		Actions mouseActions = new Actions(this.driver);
		Thread.sleep(1000);
		
		//major versions
		this.wait.until(ExpectedConditions.visibilityOf(this.driver.findElement(By.linkText(majorVersions))));
		System.out.println(this.driver.findElement(By.linkText(majorVersions)).getText());
		this.driver.findElement(By.linkText(majorVersions)).click();
		
		//minor versions
		mouseActions.moveToElement(this.driver.findElement(By.cssSelector("div[class='version-info']")).findElement(By.className("btn-group")).findElement(By.cssSelector("button[class='btn dropdown-toggle btn-info']"))).click().perform();
		Thread.sleep(2000);
		this.driver.findElement(By.tagName("body")).sendKeys(Keys.TAB);
		Thread.sleep(1000);
        mouseActions.moveToElement(this.driver.findElement(By.linkText(minorVersions))).click().perform();
			
		
				
		//move to bottom of the page
        JavascriptExecutor jse = (JavascriptExecutor)this.driver;
	    jse.executeScript("window.scrollTo(0, document.body.scrollHeight)");
		
		this.wait.until(ExpectedConditions.visibilityOf(this.buttonNext));
		if(this.buttonNext.isEnabled())
		{
			this.buttonNext.click();
			Thread.sleep(7000);
			System.out.println("Select Version Step Successful");
		}
		
	}
}
	
	


