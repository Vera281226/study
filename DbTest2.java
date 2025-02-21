package pack;
// Jar에는 Runnable Jar이 있으며 이것으로 실행시키는 파일을 만들어 cmd 같은 곳에서 실행 시킬수 있다 
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class DbTest2 {
// 직원번호 직원 직급 부서명      직원 테이블 이용 부서 테이블 조인 직급 조건-사원,대리
// 인원수 :
	private Connection connection=null;
	private Statement statement=null;
	private ResultSet resultset=null;
	
	public DbTest2() {
		try {
			Class.forName("org.mariadb.jdbc.Driver");		
		}catch(Exception e) {System.out.println("로딩 실패 : "+e.getMessage()); return;}
		try {
			connection=DriverManager.getConnection("jdbc:mariadb://localhost:3306/test", "root", "123");
		}catch(Exception e) {System.out.println("연결 실패 : "+e.getMessage()); return;}
		try {
			statement=connection.createStatement();
			String sql="SELECT jikwonno, jikwonname, jikwonjik, busername "
					 + "FROM jikwon INNER JOIN buser ON busernum=buserno "
					 + "WHERE jikwonjik IN('사원','대리')";
			resultset=statement.executeQuery(sql);
			System.out.println("직원 번호\t직원명\t직급\t부서명");
			int count = 0;
			while(resultset.next()) {
				String no=resultset.getString(1);
				String name=resultset.getString(2);
				String jik=resultset.getString(3);
				String buname=resultset.getString(4);
				System.out.println(no+"\t"+name+"\t"+jik+"\t"+buname);
				count++;
			}
			System.out.println("인원수 : "+count);
		}catch(Exception e) {System.out.println("처리 실패 : "+e.getMessage()); return;}
		finally {
			try {
				if(resultset!=null)resultset.close();
				if(statement!=null)statement.close();
				if(connection!=null)connection.close();
			}catch (Exception e){System.out.println("종료 에러");}
		}
	}
	
	public static void main(String[] args) {
		new DbTest2();
	}
}