using System.Runtime.Serialization;

namespace GeolocationRuntimeComponent
{

    [DataContract]
    public sealed class AddressParam
    {
        [DataMember(Name = "addressLine")]
        public string AddressLine { get; set; }
    }
}
