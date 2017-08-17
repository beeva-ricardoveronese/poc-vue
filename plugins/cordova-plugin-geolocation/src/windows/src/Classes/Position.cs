using System.Runtime.Serialization;

namespace GeolocationRuntimeComponent
{
    [DataContract]
    public sealed class Position
    {
        [DataMember(Name = "accuracy")]
        public int Accuracy { get; set; }
        [DataMember(Name = "latitude")]
        public double Latitude { get; set; }
        [DataMember(Name = "longitude")]
        public double Longitude { get; set; }
        [DataMember(Name = "altitude")]
        public int Altitude { get; set; }
    }
}
