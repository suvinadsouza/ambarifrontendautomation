package AmbariPageObjects;

import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.annotations.Test;

public class Deploy {
	
	//declare variables
		protected WebDriver driver;
		protected WebDriverWait wait;
		protected Actions mouseActions;
		protected JavascriptExecutor jse;
		
		@FindBy(css="button[class= 'btn btn-success pull-right']")
		protected WebElement buttonNext;
		
		
	//constructor
		public Deploy(WebDriver driver)
		{
			this.driver=driver;
			this.wait = new WebDriverWait(driver, 7200);
			this.mouseActions = new Actions(this.driver);
			this.jse = (JavascriptExecutor)this.driver;
			this.driver.manage().window().maximize();
		}
		
		@Test
		public void DeployAmbari() throws InterruptedException
		{
			//scroll to bottom of page
			this.jse.executeScript("window.scrollTo(0, document.body.scrollHeight)");
			this.wait.until(ExpectedConditions.elementToBeClickable(this.buttonNext));
			this.buttonNext.click();
			Thread.sleep(8000);
			//scroll to bottom of page
			this.driver.manage().window().maximize();
			this.jse.executeScript("window.scrollTo(0, document.body.scrollHeight)");
			
			while(!(this.driver.getPageSource().contains("Failed to install")))
			{
				
				
				//click on retry incase of failures
				if(this.driver.getPageSource().contains("Failed to install"))
				{
					this.wait.until(ExpectedConditions.elementToBeClickable(this.driver.findElement(By.cssSelector("a[class='btn btn-primary']"))));
					this.driver.findElement(By.cssSelector("a[class='btn btn-primary']")).click();
					Thread.sleep(5000);
					continue;
				}
				
				if(this.driver.getPageSource().contains("Successfully installed and started the services"))
				{
					this.wait.until(ExpectedConditions.elementToBeClickable(this.buttonNext));
					this.buttonNext.click();
					Thread.sleep(2000);
					//scroll to bottom of page
					this.driver.manage().window().maximize();
					this.jse.executeScript("window.scrollTo(0, document.body.scrollHeight)");
					this.wait.until(ExpectedConditions.elementToBeClickable(this.buttonNext));
					this.buttonNext.click();
					Thread.sleep(2000);
					break;
				}
				else
				{
					continue;
				}
			}
			
			
			Thread.sleep(5000);
			System.out.println("Deploy Step Successful");
			
		}


}
