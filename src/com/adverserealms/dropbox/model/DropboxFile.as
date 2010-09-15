package com.adverserealms.dropbox.model
{	
	import flash.utils.Dictionary;
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class DropboxFile
	{
		public static var directoryCache:Dictionary = new Dictionary();
		
		public function DropboxFile(path:String = "") {
			this.path = path;
		}
		
		public var hash:String;
		public var revision:String;
		public var thumbExists:Boolean;
		public var bytes:Number;
		public var modified:Date;
		public var path:String;
		public var filename:String;
		public var isDir:Boolean;
		public var icon:String;
		public var mimeType:String;
		public var size:String;			//preformatted text based on bytes sets bytes, kb, gb, etc...
		public var root:String;
		
		public var parent:DropboxFile;
		
		public var contents:ArrayCollection;
	}
}