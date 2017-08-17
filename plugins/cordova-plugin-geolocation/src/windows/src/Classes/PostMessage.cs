using System.Runtime.Serialization;

namespace GeolocationRuntimeComponent
{
    [DataContract]
    public sealed class PostMessage
    {
        [DataMember(Name = "pluginName")]
        public string PluginName { get; set; }

        [DataMember(Name = "payload")]
        public object Payload { get; set; }

        [DataMember(Name = "origin")]
        public string Origin { get; set; }

        [DataMember(Name = "action")]
        public string Action { get; set; }

        public PostMessage(string action, string origin, string pluginName)
        {
            this.Action = action;
            this.Origin = origin;
            this.PluginName = pluginName;
        }
    }
}
