package AmbariPageObjects;

import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.annotations.Test;

public class AssignSlavesAndClients {
	
	//declare variables
    protected WebDriver driver;
    protected WebDriverWait wait;
	protected Actions mouseActions;
	protected JavascriptExecutor jse;
		
	@FindBy(css="a[id= 'all-CLIENT']")
	protected WebElement linkAllClients;
		
	@FindBy(css="button[class= 'btn btn-success pull-right']")
	protected WebElement buttonNext;
	
	//constructor
	public AssignSlavesAndClients(WebDriver driver)
	{
		this.driver=driver;
		this.wait = new WebDriverWait(driver, 180);
		this.mouseActions = new Actions(this.driver);
		this.jse = (JavascriptExecutor)this.driver;
		this.driver.manage().window().maximize();
		
	}
	
	@Test
	public void AssignSlavesAndClientsProcess()
	{
		
		wait.until(ExpectedConditions.elementToBeClickable(this.buttonNext));
		
				
		jse.executeScript("arguments[0].scrollIntoView();", this.linkAllClients);
		mouseActions.moveToElement(this.linkAllClients).click().perform();
		
		wait.until(ExpectedConditions.elementToBeClickable(this.buttonNext));
		
		if(this.buttonNext.isEnabled())
		{
			this.buttonNext.click();
			System.out.println("Assign Slaves and Clients Step Successful");
		}
	}

}
