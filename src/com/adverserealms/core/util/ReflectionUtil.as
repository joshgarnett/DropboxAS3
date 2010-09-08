package com.adverserealms.core.util
{
    import flash.utils.describeType;
    
    public class ReflectionUtil
    {
        /**
        * Retrieve the qualified name of an object's class
        */
        public static function getQualifiedClassName(obj:*):String
        {
            return describeType(obj).@name;
        }
        
        /**
        * Retrieve the name of an object's class
        */
        public static function getClassName(obj:*):String
        {
            return getQualifiedClassName(obj).split("::")[1];
        }
        
        /**
        * Retrieve a reference to an object's constructor
        */
        public static function getClassObject(obj:*):Class
        {
            return (Object(obj)).constructor as Class
        }
        
        public static function isDerived(childClass:Class, ancestorClass:Class):Boolean
        {
            return ancestorClass.prototype.isPrototypeOf(childClass.prototype) as Boolean;
        }
    }
}