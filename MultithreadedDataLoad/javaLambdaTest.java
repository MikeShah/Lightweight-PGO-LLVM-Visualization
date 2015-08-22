public class{

	public static void main(String[] args){

		
		Runnable task = () -> {
      			String threadName = Thread.currentThread().getName();
  			System.out.println("Test thread: "+threadName);
		};

		Thread test01 = new Thread(task);
		test01.start();

	
		return 0;
	}
}
