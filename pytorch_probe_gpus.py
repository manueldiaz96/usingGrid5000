import torch

n_gpus = torch.cuda.device_count()
for gpu in range(n_gpus):
	print("%s detected on device %d"%(torch.cuda.get_device_name(gpu),gpu))

