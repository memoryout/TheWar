package main.boot.sqllite
{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	import main.boot.IService;
	import main.boot.ServicesList;
	import main.boot.interfaces.ISQLManager;
		
	public class SQLManager implements ISQLManager, IService
	{
		private var _connection:			SQLConnection;
		private var _isConnected:			Boolean;
		
		private const _quaryList:			Vector.<SQLRequest> = new Vector.<SQLRequest>;
		
		private var _isProcessed:			Boolean;
		private var _currentRequest:		SQLRequest;
		private var _currentStatement:		SQLStatement;
		
		private var _onCompleteConnect:		Function;
		private var _onErrorConnect:		Function;
		
		
		public function SQLManager()
		{
			_isProcessed = false;
			_isConnected = false;
		}
		
		
		public static function init():void
		{
			ServicesList.addSearvice( new SQLManager() );
		}
		
		
		public function get serviceName():String
		{
			return ServicesList.SQL_MANAGER;
		}
		
		
		public function connect(url:String, onComplete:Function, onError:Function):void
		{
			_onCompleteConnect = onComplete;
			_onErrorConnect = onError;
			
			_connection = new SQLConnection();
			_connection.addEventListener(SQLEvent.OPEN, handlerOpen);
			_connection.addEventListener(SQLErrorEvent.ERROR, handlerErrorOpen);
			
			var file:File = File.applicationDirectory;
			file.url += url;
			
			_connection.openAsync(file, SQLMode.UPDATE);
		}
		
		
		public function executeRequest(request:SQLRequest):void
		{
			_quaryList.push(request);
			
			tryExecuteRequest();
		}
		
		
		public function closeConnection():void
		{
			_connection.close();
		}
		
		
		private function tryExecuteRequest():void
		{
			if(_isConnected && !_isProcessed && _quaryList.length)
			{
				_isProcessed = true;
				
				_currentRequest = _quaryList.shift();
				
				_currentStatement = new SQLStatement();
				_currentStatement.text = _currentRequest.request;
				
				if(_currentRequest.requestParams)
				{
					var par:String;
					for(par in _currentRequest.requestParams) _currentStatement.parameters[par] = _currentRequest.requestParams[par];
				}
				
				_currentStatement.sqlConnection = _connection;
				
				trace(_currentStatement.text);
				
				_currentStatement.addEventListener(SQLEvent.RESULT, handlerRequestResult);
				_currentStatement.addEventListener(SQLErrorEvent.ERROR, handlerErrorRequest);
				_currentStatement.execute();
				
				if(_connection.inTransaction) _connection.commit();
			}
		}
		
		private function handlerErrorOpen(e:SQLErrorEvent):void
		{
			_connection.removeEventListener(SQLEvent.OPEN, handlerOpen);
			_connection.removeEventListener(SQLErrorEvent.ERROR, handlerErrorOpen);
			
			_onCompleteConnect = null;
			if(_onErrorConnect != null) _onErrorConnect();
			_onErrorConnect = null;
		}
		
		
		private function handlerOpen(e:SQLEvent):void
		{
			_connection.removeEventListener(SQLEvent.OPEN, handlerOpen);
			
			_connection.addEventListener(SQLEvent.BEGIN, handlerSQLBegin);
			_connection.begin();
		}
		
		
		private function handlerSQLBegin(e:SQLEvent):void
		{
			_connection.removeEventListener(SQLEvent.BEGIN, handlerSQLBegin);
			
			_isConnected = true;
			_isProcessed = false;
			
			_onErrorConnect = null;
			if(_onCompleteConnect != null) _onCompleteConnect();
			_onCompleteConnect = null;
			
			tryExecuteRequest();
		}
		
		
		
		
		private function handlerRequestResult(e:SQLEvent):void
		{
			_currentStatement.addEventListener(SQLEvent.RESULT, handlerRequestResult);
			_currentStatement.addEventListener(SQLErrorEvent.ERROR, handlerErrorRequest);
			
			var sqlResult:SQLResult = (e.currentTarget as SQLStatement).getResult();
			
			_currentRequest.onResult( sqlResult.data );
			
			_isProcessed = false;
			tryExecuteRequest();
		}
		
		
		private function handlerErrorRequest(e:SQLErrorEvent):void
		{
			_currentStatement.addEventListener(SQLEvent.RESULT, handlerRequestResult);
			_currentStatement.addEventListener(SQLErrorEvent.ERROR, handlerErrorRequest);
			trace(e.toString())
			_currentRequest.onErrorResult(e.toString());
			
			_isProcessed = false;
			tryExecuteRequest();
		}
		
		
		private function traceDirrectoryList(file:File):void
		{
			if(file.isDirectory)
			{
				trace("folder: " + file.url);
				
				var arr:Array = file.getDirectoryListing();
				var i:int;
				var f:File;
				for(i = 0; i < arr.length; i++)
				{
					f = arr[i];
					if(f.isDirectory) traceDirrectoryList(f);
					else trace("file: " + f.url);
				}
			}
		}
	}
}