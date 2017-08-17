
using System.Runtime.Serialization;


namespace GeolocationRuntimeComponent
{

    [DataContract]
    public sealed class WatchLocationParam
    {
        [DataMember(Name = "interval")]
        public long interval { get; set; }
    }
}
