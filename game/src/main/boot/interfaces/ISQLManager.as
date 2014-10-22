package main.boot.interfaces
{
	import main.boot.sqllite.SQLRequest;

	public interface ISQLManager
	{
		function connect(url:String, onConnect:Function, onError:Function):void;
		function executeRequest(request:SQLRequest):void;
		function closeConnection():void;
	}
}