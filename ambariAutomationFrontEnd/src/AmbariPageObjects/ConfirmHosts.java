package AmbariPageObjects;

import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.annotations.Test;

public class ConfirmHosts {
	
	//declare variables
	protected WebDriver driver;
	protected WebDriverWait wait;
	
	@FindBy(css="button[class= 'btn btn-success pull-right']")
	protected WebElement buttonNext;
	
	//constructor
	public ConfirmHosts(WebDriver driver)
	{
		this.driver=driver;
		this.wait = new WebDriverWait(driver, 3600);
		this.driver.manage().window().maximize();
	}
	
	@Test
	public int ConfirmHostsProcess() throws InterruptedException
	{
		wait.until(ExpectedConditions.elementToBeClickable(this.buttonNext));
		
		if(this.buttonNext.isEnabled() && this.driver.getPageSource().contains("All host checks passed"))
		{
			System.out.println("host checks successful");
			
			//move to bottom of the page
			JavascriptExecutor jse = (JavascriptExecutor)this.driver;
		    jse.executeScript("window.scrollTo(0, document.body.scrollHeight)");
		    
			this.buttonNext.click();
			Thread.sleep(3000);
			return(1);
		}
		else
		{
			System.out.println("host checks Unsuccessful, correct the issues and run the selenium script again");
			return(0);
		}
	}

}
