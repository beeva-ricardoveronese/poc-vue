using System.Collections.Generic;
using System.Runtime.Serialization;

namespace GeolocationRuntimeComponent
{
    [DataContract]
    public sealed class Address
    {
        [DataMember(Name = "addressLine")]
        public string AddressLine { get; set; }
        [DataMember(Name = "longitude")]
        public double Longitude { get; set; }
        [DataMember(Name = "latitude")]
        public double Latitude { get; set; }
    }


    [DataContract]
    public sealed class AddressList
    {
        [DataMember(Name = "address")]
        public IList<Address> Address { get; set; }
    }
}
