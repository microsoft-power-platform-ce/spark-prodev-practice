using Microsoft.Xrm.Sdk;
using System;

namespace Cr90c73.Admin.Plugins
{
    public class AutoPopulateFoo : IPlugin
    {
        public void Execute(IServiceProvider serviceProvider)
        {
            var context = (IPluginExecutionContext)serviceProvider.GetService(
                typeof(IPluginExecutionContext)
            );
            var target = (Entity)context.InputParameters["Target"];
            var random = new Random();
            target["crc8e_foo"] = random.Next().ToString();
        }
    }
}
