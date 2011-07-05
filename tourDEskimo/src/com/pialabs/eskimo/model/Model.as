package
{
  import com.pialabs.eskimo.model.Category;
  import com.pialabs.eskimo.model.Sample;
  import com.pialabs.eskimo.model.Samples;

	public class Model
	{
		private static var instance:Model;
    
		public static function getInstance():Model
		{
			if (instance == null)
			{
				instance = new Model();
			}
			
			return instance;
		}
		
		[Bindable] public var samples:Category;
		[Bindable] public var currentItem:Sample;
		
		public function Model()
		{
			samples = new Samples();
			currentItem = samples;
		}
		
		public function findParent(item:Sample):Category
		{
			return getParentOf(item, samples);
		}
		
		protected function getParentOf(item:Sample, searchNode:Category):Category
		{
			for each(var sample:Sample in searchNode.samples)
			{
				if (sample == item)
				{
					return searchNode;
				}
				else if (sample is Category)
				{
					var category:Category = getParentOf(item, sample as Category);
					if (category != null)
					{
						return category;
					}
				}
			}
			return null;
		}
	}
}