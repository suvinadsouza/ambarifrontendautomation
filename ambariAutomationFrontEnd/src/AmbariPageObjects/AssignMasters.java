package AmbariPageObjects;

import java.util.List;

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

public class AssignMasters {
	
	//declare variables
	protected WebDriver driver;
	protected WebDriverWait wait;
	protected Actions mouseActions;
	protected JavascriptExecutor jse;
	
	static String[] hosts;
	
	@FindBy(css="button[class= 'btn btn-success pull-right']")
	protected WebElement buttonNext;
	
	//constructor
	public AssignMasters(WebDriver driver)
	{
		this.driver=driver;
		this.wait = new WebDriverWait(driver, 180);
		this.mouseActions = new Actions(this.driver);
		this.jse = (JavascriptExecutor)this.driver;
		this.driver.manage().window().maximize();
	}
	
	@Test
	public void AssignMastersProcess(String masterComponents) throws InterruptedException
	{
		wait.until(ExpectedConditions.elementToBeClickable(this.buttonNext));
		
		String[] searchstring_services = masterComponents.split("#");
			
		
		for(int i=0;i<searchstring_services.length;i++)
		{
			System.out.println(searchstring_services[i].toString());
			List<WebElement> labels = this.driver.findElements(By.cssSelector("label[class='pts pull-right']"));		
			String[] hosts = searchstring_services[i].split("-");
					
			System.out.println(hosts[0].toString());
			System.out.println(hosts[1].toString());
			
			//move to top of page
			JavascriptExecutor js = (JavascriptExecutor)this.driver;
			js.executeScript("window.scrollTo(0, 0)");
			Thread.sleep(2000);
		
			for(WebElement e: labels)
			{
				System.out.println(e.getText());
				
				if(hosts[0].toString().matches(e.getText().toString()))
				{
					jse.executeScript("arguments[0].scrollIntoView();", e);
					mouseActions.moveToElement(e).click().perform();
					Thread.sleep(1000);
					this.driver.findElement(By.tagName("body")).sendKeys(Keys.TAB);
					this.driver.switchTo().activeElement();
					mouseActions.sendKeys(hosts[1].toString()).perform();
					mouseActions.click().perform();
					Thread.sleep(2000);
				    			    
				    break;
				}
			}
			
			labels.removeAll(labels);
			Thread.sleep(1000);
			
		}
		
		//move to bottom of the page
		Thread.sleep(2000);
		jse.executeScript("window.scrollTo(0, document.body.scrollHeight)");
		Thread.sleep(2000);
	    
		if(this.buttonNext.isEnabled())
		{
			this.buttonNext.click();
			Thread.sleep(3000);
			System.out.println("Assign Masters Step Successful");
		}
	}//end of function

}
