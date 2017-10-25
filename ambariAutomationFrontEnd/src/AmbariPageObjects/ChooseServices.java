package AmbariPageObjects;

import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.annotations.Test;

public class ChooseServices {
	
	    //declare variables
		protected WebDriver driver;
		protected WebDriverWait wait;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox']")
		protected WebElement checkboxSelectAll;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox HDFS']")//1
		protected WebElement checkboxHDFS;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox YARN']")//2
		protected WebElement checkboxYARN;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox TEZ']")//3
		protected WebElement checkboxTez;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox HIVE']")//4
		protected WebElement checkboxHive;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox HBASE']")//5
		protected WebElement checkboxHbase;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox PIG']")//6
		protected WebElement checkboxPig;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox SQOOP']")//7
		protected WebElement checkboxSqoop;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox OOZIE']")//8
		protected WebElement checkboxOozie;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox ZOOKEEPER']")//9
		protected WebElement checkboxZookeeper;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox FALCON']")//10
		protected WebElement checkboxfalcon;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox STORM']")//11
		protected WebElement checkboxStorm;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox FLUME']")//12
		protected WebElement checkboxFlume;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox ACCUMULO']")//13
		protected WebElement checkboxAccumulo;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox AMBARI_INFRA']")//14
		protected WebElement checkboxAmbari_Infra;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox AMBARI_METRICS']")//15
		protected WebElement checkboxAmbari_Metrics;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox ATLAS']")//16
		protected WebElement checkboxAtlas;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox KAFKA']")//17
		protected WebElement checkboxKafka;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox KNOX']")//18
		protected WebElement checkboxKnox;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox LOGSEARCH']")//19
		protected WebElement checkboxLogSerach;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox SPARK']")//20
		protected WebElement checkboxSpark;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox SPARK2']")//21
		protected WebElement checkboxSpark2;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox ZEPPELIN']")//22
		protected WebElement checkboxZeppelin;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox DRUID']")//23
		protected WebElement checkboxDruid;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox MAHOUT']")//24
		protected WebElement checkboxMahout;
		
		@FindBy(css="input[class= 'ember-view ember-checkbox SLIDER']")//25
		protected WebElement checkboxSlider;
		
		@FindBy(css="button[class= 'btn btn-success pull-right']")
		protected WebElement buttonNext;
		
		//constructor
		public ChooseServices(WebDriver driver)
		{
			this.driver=driver;
			this.wait = new WebDriverWait(driver, 5);
			this.driver.manage().window().maximize();
		}
		
		@Test
		public void ChooseServicesProcess(String Services) throws InterruptedException
		{
			JavascriptExecutor jse = (JavascriptExecutor)this.driver;
			
			wait.until(ExpectedConditions.elementToBeClickable(this.buttonNext));
			
			//scroll to top of page
			jse.executeScript("window.scrollTo(0, 0)");
			
			if(this.checkboxSelectAll.isEnabled())
			{
				this.checkboxSelectAll.click();
			}
			
			String[] searchstring_services = Services.split(" ");
			
			for(int i=0;i<searchstring_services.length;i++)
			{
						
				if(searchstring_services[i].contains("hdfs"))//1
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxHDFS);
					this.checkboxHDFS.click();
				}
				
				if(searchstring_services[i].contains("yarn"))//2
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxYARN);
					this.checkboxYARN.click();
				}
				
				if(searchstring_services[i].contains("tez"))//3
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxTez);
					this.checkboxTez.click();
				}
				
				if(searchstring_services[i].contains("hive"))//4
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxHive);
					this.checkboxHive.click();
				}
				
				if(searchstring_services[i].contains("hbase"))//5
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxHbase);
					this.checkboxHbase.click();
				}
				
				if(searchstring_services[i].contains("pig"))//6
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxPig);
					this.checkboxPig.click();
				}
				
				if(searchstring_services[i].contains("sqoop"))//7
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxSqoop);
					this.checkboxSqoop.click();
				}
				
				if(searchstring_services[i].contains("oozie"))//8
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxOozie);
					this.checkboxOozie.click();
				}
				
				if(searchstring_services[i].contains("zookeeper"))//9
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxZookeeper);
					this.checkboxZookeeper.click();
				}
				
				if(searchstring_services[i].contains("falcon"))//10
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxfalcon); 
					this.checkboxfalcon.click();
				}
				
				if(searchstring_services[i].contains("storm"))//11
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxStorm); 
					this.checkboxStorm.click();
				}
				
				if(searchstring_services[i].contains("flume"))//12
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxFlume); 
					this.checkboxFlume.click();
				}
				
				if(searchstring_services[i].contains("accumulo"))//13
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxAccumulo); 
					this.checkboxAccumulo.click();
				}
				
				if(searchstring_services[i].contains("ambari_infra"))//14
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxAmbari_Infra); 
					this.checkboxAmbari_Infra.click();
				}
				
				if(searchstring_services[i].contains("ambari_metrics"))//15
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxAmbari_Metrics); ;
					this.checkboxAmbari_Metrics.click();
				}
				
				if(searchstring_services[i].contains("atlas"))//16
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxAtlas); 
					this.checkboxAtlas.click();
				}
				
				if(searchstring_services[i].contains("kafka"))//17
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxKafka); 
					this.checkboxKafka.click();
				}
				
				if(searchstring_services[i].contains("knox"))//18
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxKnox); 
					this.checkboxKnox.click();
				}
				
				if(searchstring_services[i].contains("logsearch"))//19
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxLogSerach);
					this.checkboxLogSerach.click();
				}
				
				//move to bottom of the page
				jse.executeScript("window.scrollTo(0, document.body.scrollHeight)");
							
				if(searchstring_services[i].contains("spark"))//20
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxSpark);
					this.checkboxSpark.click();
				}
				
				if(searchstring_services[i].contains("spark2"))//21
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxSpark2);
					this.checkboxSpark2.click();
				}
				
				if(searchstring_services[i].contains("zeppelin"))//22
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxZeppelin);
					this.checkboxZeppelin.click();
				}
				
				if(searchstring_services[i].contains("druid"))//23
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxDruid);
					this.checkboxDruid.click();
				}
				
				if(searchstring_services[i].contains("mahout"))//24
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxMahout);
					this.checkboxMahout.click();
				}
				
				if(searchstring_services[i].contains("slider"))//25
				{
					jse.executeScript("arguments[0].scrollIntoView();", this.checkboxSlider);
					this.checkboxSlider.click();
				}
			}//end of for loop
			
			if(this.buttonNext.isEnabled())
			{
				this.buttonNext.click();
				Thread.sleep(5000);
				System.out.println("Choose Services Step Successful");
			}
		}

}
